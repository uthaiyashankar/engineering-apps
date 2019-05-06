//Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/mysql;
import ballerina/sql;
import ballerina/config;

mysql:Client employeeDB = new ({
    host: config:getAsString("EMPLOYEE_DB_HOST"),
    port: config:getAsInt("EMPLOYEE_DB_PORT"),
    name: config:getAsString("EMPLOYEE_DB_NAME"),
    username: config:getAsString("EMPLOYEE_DB_USERNAME"),
    password: config:getAsString("EMPLOYEE_DB_PASSWORD"),
    dbOptions: { useSSL: false }
});

type DatabaseError error<string>;

function getAllEmployees() returns json|DatabaseError{
    var employeesRet = employeeDB->select("SELECT * FROM ENGAPP_EMPLOYEES", ());
    if (employeesRet is table<record {}>) {
        //Convert the table into json to return
        var jsonConversionRet = json.convert(employeesRet);
        if (jsonConversionRet is json) {
            return untaint jsonConversionRet; //There is nothing to taint process
        } else {
            //We couldn't convert this. This should be an error
            DatabaseError dbError = error("Error in table to json conversion");
            return dbError;
        }
    } else {
        //We didn't get a record set. Check the error message
        DatabaseError dbError = error("Select data from student table failed: "
                + <string>employeesRet.detail().message);
        return dbError;
    }
}