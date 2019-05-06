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

# A service is a network-accessible API
# Advertised on '/hello', port comes from listener endpoint
@http:ServiceConfig {
    basePath: "github-user"
}
service github_user on new http:Listener(9090) {

    # A resource is an invokable API method
    # Accessible at '/hello/sayHello
    # 'caller' is the client invoking this resource 

    # + caller - Server Connector
    # + request - Request
    @http:ResourceConfig {
        path: "users"
    }
    resource function users(http:Caller caller, http:Request request) {

        // Create object to carry data back to caller
        http:Response response = new;

        // Set a string payload to be sent to the caller
        response.setTextPayload("Hello Ballerina!");

        // Send a response back to caller
        // -> indicates a synchronous network-bound call
        error? result = caller -> respond(response);
        if (result is error) {
            io:println("Error in responding", result);
        }    }
}