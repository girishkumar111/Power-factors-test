@IsTest
public with sharing class CalenderServiceTest {
    @IsTest
    public static void TestGetHolidays() {
        CalenderService service = new CalenderService();

        Test.startTest();
        CalenderService.ResponseWrapper result = service.getHolidays('ca', 2021);
        System.assertEquals(result.meta.code, 200);
        Test.stopTest();
    }
}