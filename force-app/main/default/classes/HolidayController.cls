public with sharing class HolidayController {
    @AuraEnabled(cacheable=true)
    public static InitialDataWrapper getInitialData(){
        return new InitialDataWrapper(getSelectedHolidays(), fetchHolidayList());
    }

    @AuraEnabled(cacheable=true)
    public static CalenderService.ResponseWrapper fetchHolidayList(){
        CalenderService.ResponseWrapper result;

        try {
            CalenderService service = new CalenderService();

			result = service.getHolidays('ca', 2021);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSelectedHolidays(){
        List<String> result = new List<String>();

        try {
            User usr = [SELECT Id, Selected_Holidays__c FROM User WHERE Id = :UserInfo.getUserId()];
            
            result = usr.Selected_Holidays__c?.split(',');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return result;
    }

    @AuraEnabled
    public static void saveSelectedHolidays(List<String> selectedHolidays) {
        try {
            User usr = [SELECT Id, Selected_Holidays__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            System.debug('test : ' + String.join(selectedHolidays, ','));
            usr.Selected_Holidays__c = String.join(selectedHolidays, ',');

            Update usr;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class InitialDataWrapper {
        @AuraEnabled
        public List<String> selectedHolidays;
        @AuraEnabled
        public CalenderService.ResponseWrapper holidaysData;

        public InitialDataWrapper(List<String> selectedHolidays, CalenderService.ResponseWrapper holidaysData) {
            this.selectedHolidays = selectedHolidays;
            this.holidaysData = holidaysData;
        }
    }
}