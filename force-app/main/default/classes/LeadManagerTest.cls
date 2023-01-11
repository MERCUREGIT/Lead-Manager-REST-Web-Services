/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 11/01/2023
 * Description: Test the lead creation process
 */

@isTest
public without sharing class LeadManagerTest {
   @isTest static void createLeadTest(){
    RestRequest request = new RestRequest();
    request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Lead/v1/';
    request.httpMethod = 'POST';
    request.addHeader('Content-Type', 'application/json');
    String body = '{"firstName": "Test", "lastName": "Test2", "address": "123 Main St", "city": "USAville","stateProvince": "PA","postalCode": "12345","primaryPhone": "5558675309","email": "lontee111930@gmail.com","leadOid": 135911130,"leadSource": "HomeAdvisor","interview": [{"question": "What kind of location is this?","answer": "Home/Residence"}, {"question": "Request Stage","answer": "Ready to Hire"}, {"question": "Desired Completion Date","answer": "Within 1 week"}]}';

    request.requestBody = Blob.valueOf(body);

    RestContext.request = request;

    
    LeadManager.createLead();
    
    list<lead> newLead = [SELECT id, firstname, lastname, email FROM Lead];
    list<Lead_Interview__c> newLeadInterviewList = [SELECT id FROM Lead_Interview__c ];
    System.assertEquals(1, newLead.size());
    System.assertEquals(3, newLeadInterviewList.size());

   }
   @isTest static void createLeadWithExistingInterviewsAndLeadWithEmailTest(){
    RestRequest request = new RestRequest();
    request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Lead/v1/';
    request.httpMethod = 'POST';
    request.addHeader('Content-Type', 'application/json');
    String body = '{"firstName": "Test", "lastName": "Test2", "address": "123 Main St", "city": "USAville","stateProvince": "PA","postalCode": "12345","primaryPhone": "5558675309","email": "lontee111930@gmail.com","leadOid": 135911130,"leadSource": "HomeAdvisor","interview": [{"question": "What kind of location is this?","answer": "Home/Residence"}, {"question": "Request Stage","answer": "Ready to Hire"}, {"question": "Desired Completion Date","answer": "Within 1 week"}]}';

    request.requestBody = Blob.valueOf(body);

    RestContext.request = request;
    LeadManager.createLead();
     body = '{"firstName": "Test", "lastName": "Test2", "address": "123 Main St", "city": "USAville","stateProvince": "PA","postalCode": "12345","primaryPhone": "5558675309","email": "lontee111930@gmail.com","leadOid": 135911130,"leadSource": "HomeAdvisor","interview": [{"question": "What kind of location is this? 1","answer": "Home/Residence"}]}';
    LeadManager.createLead();

    list<lead> newLead = [SELECT id, firstname, lastname, email FROM Lead];
    list<Lead_Interview__c> newLeadInterviewList = [SELECT id, question__c, answer__c,Lead__c FROM Lead_Interview__c ];
    System.assertEquals(1, newLead.size());

   }
   @isTest static void createLeadWithWrongJsonTest(){
    RestRequest request = new RestRequest();
    request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Lead/v1/';
    request.httpMethod = 'POST';
    request.addHeader('Content-Type', 'application/json');
    String body = '"firstName": "Test", "lastName": "Test2", "address": "123 Main St", "city": "USAville","stateProvince": "PA","postalCode": "12345","primaryPhone": "5558675309","email": "lontee111930@gmail.com","leadOid": 135911130,"leadSource": "HomeAdvisor","interview": [{"question": "What kind of location is this?","answer": "Home/Residence"}, {"question": "Request Stage","answer": "Ready to Hire"}, {"question": "Desired Completion Date","answer": "Within 1 week"}]}';

    request.requestBody = Blob.valueOf(body);
    RestContext.request = request;
    LeadManager.createLead();

    list<lead> newLead = [SELECT id, firstname, lastname, email FROM Lead];
    list<Lead_Interview__c> newLeadInterviewList = [SELECT id FROM Lead_Interview__c ];
    System.assertEquals(0, newLead.size());
    System.assertEquals(0, newLeadInterviewList.size());

   }

}
