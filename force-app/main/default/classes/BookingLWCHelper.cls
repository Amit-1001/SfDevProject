public with sharing class BookingLWCHelper {
    
    
    public BookingLWCHelper() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Product__c> searchProduct(String productName){
        return [select Id, Name,Stock_Quantity__c from Product__c where Name like : ('%' + productName + '%')];
    }

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> searchBooking(String bookingName){
        return [SELECT Id, Name, Product__r.Name, Product__r.TotalBooking__c FROM Booking__c WHERE Name LIKE :('%' + bookingName + '%')];

    }


}