@isTest
public class septaTrainsMocksTEST {    
    public class HTTPErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(404);
            r.setBody('');
            
            return r;
        }
    }
    
    public class JSONErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(200);
            r.setBody('{ "error": "this is the error message" }');
            
            return r;
        }
    }

    public class DevilMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(200);
            r.setBody('Invalid JSON: [}]}');
            
            return r;
        }
    }

}
