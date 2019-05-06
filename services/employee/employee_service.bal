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

import ballerina/http;
import ballerina/io;
import ballerina/config;

# Advertised on '/employee', port comes from listener endpoint
@http:ServiceConfig {
    basePath: "/employee"
}
service employee on new http:Listener(config:getAsInt("EMPLOYEE_SERVICE_LISTEN_PORT", defaultValue = 9090)) {

    # Accessible at '/employee
    # 'caller' is the client invoking this resource 

    # + caller - Server Connector
    # + request - Request
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function getAllEmployees(http:Caller caller, http:Request request) {
        // Create object to carry data back to caller
        http:Response response = new;

        var returnedEmployees = getAllEmployees();
        if (returnedEmployees is json){
            //already tainted. Nothing to taint
            json employees = untaint returnedEmployees;
            response.setJsonPayload(employees, contentType = "application/json");
        } else {
            string errorMsg = untaint <string>returnedEmployees.reason();
            response.setTextPayload(errorMsg, contentType = "text/plain");
        }

        // Send a response back to caller
        error? result = caller -> respond(response);
        if (result is error) {
            io:println("Error in responding", result);
        }    
    }
}