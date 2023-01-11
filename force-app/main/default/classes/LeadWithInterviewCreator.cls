/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 11/01/2023
 * Description: Helper class for generating lead and lead interview Questions from JSON string
 */

public without sharing class LeadWithInterviewCreator {
    public static void generateLeadInterview(LeadWithInterview instance){
        lead leadInstance = new lead();
        list<lead> existingLeadList  = [SELECT id, email FROM Lead WHERE email=:instance.email];
        if(!existingLeadList.isEmpty()){
            leadInstance = existingLeadList[0];
        }
        leadInstance.LastName = instance.lastName;
        leadInstance.FirstName = instance.firstName;
        leadInstance.City = instance.city;
        leadInstance.State = instance.stateProvince;
        leadInstance.PostalCode = instance.postalCode;
        leadInstance.Phone = instance.primaryPhone;
        leadInstance.Email = instance.email;
        leadInstance.leadOid__c = instance.leadOid;
        leadInstance.LeadSource = instance.leadSource;
        leadInstance.Company = 'Company Name';

        upsert leadInstance;

        list<Lead_Interview__c> questionAndAnswers = new list<Lead_Interview__c>();

        list<Lead_Interview__c> existingInterviewInstanceList  = [SELECT id, question__c FROM Lead_Interview__c WHERE Lead__c=:leadInstance.id];

        for(Interview interviewInstance : instance.interview ){
            Lead_Interview__c singleInterview = new Lead_Interview__c();
            
            if(!existingInterviewInstanceList.isEmpty()){
                for(Lead_Interview__c existingInterview:existingInterviewInstanceList){
                    if(interviewInstance.question.toUpperCase() == existingInterview.question__c.toUpperCase()){
                        singleInterview = existingInterview;
                        singleInterview.id = existingInterview.id;
                    }else{
                        singleInterview.question__c = interviewInstance.question;
                    }
                }
            }
            else{
                singleInterview.question__c = interviewInstance.question; 
            }
            singleInterview.Lead__c = leadInstance.Id;
            singleInterview.answer__c = interviewInstance.answer;
            questionAndAnswers.add(singleInterview);
        }

       if(!questionAndAnswers.isEmpty()){
        upsert questionAndAnswers;
       }
    }


    public static void generateLeadInterview(list<LeadWithInterview> instanceList){
        

    }
}
