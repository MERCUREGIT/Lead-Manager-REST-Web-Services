/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 11/01/2023
 * Description: Controller class for requesting and deleting lead interviews
 */

public without sharing class LeadInterviewController {
   
    @AuraEnabled(cacheable=true)
    public static List<Lead_Interview__c> getLeadInterviews(string recordId){
        return [SELECT id, question__c,answer__c FROM  Lead_Interview__c WHERE lead__c =:recordId WITH SECURITY_ENFORCED];
   }

   @AuraEnabled
    public static void deleteLeadInterview(string recordId){
        list<Lead_Interview__c> leadInterviewList = [SELECT Id From Lead_Interview__c WHERE id = : recordId];
        if(!leadInterviewList.isEmpty()){
            delete leadInterviewList;
        }
    }
}
