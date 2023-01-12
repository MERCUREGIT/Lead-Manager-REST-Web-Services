public without sharing class LeadInterviewController {
   
    @AuraEnabled(cacheable=true)
    public static List<Lead_Interview__c> getLeadInterviews(string leadId){
        return [SELECT id, question__c,answer__c FROM  Lead_Interview__c WHERE lead__c =:leadId WITH SECURITY_ENFORCED];
   }

   @AuraEnabled
    public static void deleteLeadInterview(string recordId){
        list<Lead_Interview__c> leadInterviewList = [SELECT Id From Lead_Interview__c WHERE id = : recordId];
        if(!leadInterviewList.isEmpty()){
            delete leadInterviewList;
        }
    }
}
