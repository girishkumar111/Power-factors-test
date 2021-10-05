public with sharing class CalenderService {
    public String apiKey = 'd5a0305a8811286089cce25131f7c5bcd1484f16 ';
    
    public ResponseWrapper getHolidays(String country, Integer year) {
        HTTP service = new HTTP();
        HTTPRequest request = new HTTPRequest();
        String url = 'https://calendarific.com/api/v2/holidays?country=' + country + '&year=' + year + '&api_key=' + apiKey;
        String responseBody;

        request.setEndpoint(url);
        request.setMethod('GET');

        if(!Test.isRunningTest()) {
            HTTPResponse response = service.send(request);

            responseBody = response.getBody();
        } else {
            responseBody = '{"meta":{"code":200},"response":{"holidays":[{"name":"New Year Day","description":"New Year Day is the first day of a new year according to the Gregorian calendar used in Canada and many other countries.","country":{"id":"ca","name":"Canada"},"date":{"iso":"2021-01-01","datetime":{"year":2021,"month":1,"day":1}},"type":["National holiday"],"locations":"All","states":"All"}]}}';
        }

        
        if(String.isNotBlank(responseBody)) {
            responseBody = responseBody.replace('"date":', '"dateObj":');
            responseBody = responseBody.replace('"datetime":', '"datetimeObj":');
        }
            
        System.debug('Response :: ' + JSON.deserializeUntyped(responseBody));
        return (ResponseWrapper) JSON.deserialize(responseBody, ResponseWrapper.class);
    }
    
    public class ResponseWrapper {
        @AuraEnabled
		public Meta meta;
        @AuraEnabled
        public Response response;
    }
    
    public class Meta {
        @AuraEnabled
		public Integer code;
    }
    
    public class Response {
        @AuraEnabled
		public List<Holiday> holidays;
    }
    
    public class Holiday {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public Country country;
        @AuraEnabled
        public DateWrapper dateObj;
        @AuraEnabled
        public List<String> type;
        @AuraEnabled
        public String locations;
        //public String states;
    }
    
    public class Country {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
    }
    
    public class DateWrapper {
        @AuraEnabled
        public String iso;
        @AuraEnabled
        public DateTimeWrapper datetimeObj;
    }
    
    public class DateTimeWrapper {
        @AuraEnabled
        public Integer year;
        @AuraEnabled
        public Integer month;
        @AuraEnabled
        public Integer day;
    }
}