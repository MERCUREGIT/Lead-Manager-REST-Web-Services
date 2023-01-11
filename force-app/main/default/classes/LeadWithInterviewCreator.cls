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
        // Map<string,LeadWithInterview> newInterviewLeadEmailMap = new Map<string,LeadWithInterview>();
        // for(LeadWithInterview instance : instanceList){
        //     newInterviewEmailList.put(instance.email.toUpperCase(), instance);
        // }
        // set<lead> existingLeadList  = new set<lead>([SELECT id, email FROM Lead WHERE email in:newInterviewLeadEmailMap.keySet()]);
        
        // for(lead instance: existingLeadList){
        //     if(newInterviewLeadEmailMap.containsKey(instance.email.toUpperCase())) {
        //         newInterviewLeadEmailMap.get(instance.email.toUpperCase()).id = instance.id;
        //     }
        // }
        // set<lead> leadsToCreateOrUpdate = new set<lead>();
        // set<lead> leadsInterviewsToCreateOrUpdate = new set<lead>();
        // for( LeadWithInterview  instance : newInterviewLeadEmailMap.values()){
        //     lead leadInstance = new lead();
        //     leadInstance.id = instance.id;
        //     leadInstance.LastName = instance.lastName;
        //     leadInstance.FirstName = instance.firstName;
        //     leadInstance.City = instance.city;
        //     leadInstance.State = instance.stateProvince;
        //     leadInstance.PostalCode = instance.postalCode;
        //     leadInstance.Phone = instance.primaryPhone;
        //     leadInstance.Email = instance.email;
        //     leadInstance.leadOid__c = instance.leadOid;
        //     leadInstance.LeadSource = instance.leadSource;
        //     leadInstance.Company = 'Company Name';
        //     leadsToCreateOrUpdate.add(leadInstance);
        // }

        // list<lead> leadsToCreateOrUpdateList = new list<lead>(leadsToCreateOrUpdate);
        // upsert leadsToCreateOrUpdateList;

    }
}
