/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 11/01/2023
 * Description: Rest web service implementing a post Method that, recieves a json string containing lead information and the the lead corresponding * interview Q&A. This Method uses the   LeadWithInterviewCreator class generateLeadInterview method to creat leads based on either an Apex object * of a list of apex object generated from the corresponding json string.
 */


@RestResource(urlMapping='/Lead/v1/*')
global without sharing class LeadManager {
    RestRequest request = RestContext.request;
    RestResponse res = RestContext.response;

    @HttpPost
    global static void createLead() {
        RestRequest request = RestContext.request;
        string jsonString = request.requestBody.toString();
        try {
            list<LeadWithInterview> instance;
            instance= (list<LeadWithInterview>) JSON.deserialize(jsonString, list<LeadWithInterview>.class);
            LeadWithInterviewCreator.generateLeadInterview(instance);
        } catch (JSONException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        } 
        try {
            LeadWithInterview instance = (LeadWithInterview) JSON.deserialize(jsonString, LeadWithInterview.class);
            LeadWithInterviewCreator.generateLeadInterview(instance);

        } catch (JSONException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}
