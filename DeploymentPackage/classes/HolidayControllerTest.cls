@IsTest
public with sharing class HolidayControllerTest {
    @isTest
    public static void testGetInitialData() {
        Test.startTest();
        HolidayController.InitialDataWrapper result = HolidayController.getInitialData();
        System.assertEquals(result.holidaysData.meta.code, 200);
        Test.stopTest();
    }

    @isTest
    public static void testSaveSelectedHolidays() {
        Test.startTest();
        HolidayController.saveSelectedHolidays(new List<String> {'2021-11-11', '2021-12-12'});
        List<String> result = HolidayController.getSelectedHolidays();
        System.assertEquals(result.size(), 2);
        Test.stopTest();
    }
}