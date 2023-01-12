/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 */
@isTest
public class LeadInterviewControllerTest {
    @TestSetup
    static void createLeadInterviews(){
        lead newLead = new Lead(
            LastName = 'test 1',
            Company='Company Test'
        );
      insert newLead;  

      insert new list<Lead_Interview__c>{
        new Lead_Interview__c(
            question__c = 'test 1',
            answer__c ='test 1',
            Lead__c=newLead.id
          ),
        new Lead_Interview__c(
            question__c = 'test 2',
            answer__c ='test 2',
            Lead__c=newLead.id
          )
      };

    }

    @isTest 
    static void deleteLeadInterviewTest(){
        list<lead> testLead = [SELECT id FROM Lead];
        list<Lead_Interview__c> testLeadInterview = [SELECT id, answer__c, question__c FROM Lead_Interview__c WHERE lead__c =:String.valueOf(testLead[0].id)];
        id recordId = testLeadInterview[0].id;
        System.assertEquals(2, testLeadInterview.size());
        LeadInterviewController.deleteLeadInterview(String.valueOf(recordId));
        
        testLeadInterview = [SELECT id, answer__c, question__c FROM Lead_Interview__c WHERE lead__c =:String.valueOf(testLead[0].id)];

        System.assertEquals(1, testLeadInterview.size());
    }

    @isTest 
    static void getLeadInterviewsTest(){
        list<lead> testLead = [SELECT id FROM Lead];
        list<Lead_Interview__c> testLeadInterview  = LeadInterviewController.getLeadInterviews(String.valueOf(testLead[0].id));
        System.assertEquals(2, testLeadInterview.size());
    }
}

