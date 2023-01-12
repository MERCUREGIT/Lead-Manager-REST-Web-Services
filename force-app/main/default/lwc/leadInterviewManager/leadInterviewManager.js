/**
 * author: Ngum Buka Fon Nyuydze
 * organisation: Hi Corp
 * email: ngumbukafon@gmail.com
 * created-on: 12/01/2023
 */


import { api, wire, track, LightningElement } from 'lwc';

import QUESTION_FIELD from '@salesforce/schema/Lead_Interview__c.question__c';
import ANSWER_FIELD from '@salesforce/schema/Lead_Interview__c.answer__c';
import getLeadInterviewsRecords from '@salesforce/apex/LeadInterviewController.getLeadInterviews';
import deleteLeadInterview from '@salesforce/apex/LeadInterviewController.deleteLeadInterview';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class LeadInterviewManager extends LightningElement {

    @api objectApiName;
    @api recordId;
    draftValues = [];
    fecthError;
    error;
    @api constant = {
        ROWACTION_DELETE : 'delete',
    }

    fields= [
        { label: 'Question', fieldName: QUESTION_FIELD.fieldApiName, type: 'text',editable: true },
        { label: 'Answer', fieldName: ANSWER_FIELD.fieldApiName, type: 'text',editable: true },
        {
            type: 'button-icon',
            fixedWidth: 34,   
            hideLabel: true,     
            typeAttributes:
            
            {
                iconName: 'utility:delete',
                name: 'delete',
                iconClass: 'slds-icon-text-error'
            }
        }
    ];
    get tableTitle(){
        return `(${this.leadInterviewsList.length}) Interviews  for ${this.objectApiName} (ID : ${this.recordId})`;
    }

    @track
    leadInterviewsList=[];

   get  isLeadInterviewsListLoading(){
        return this.leadInterviewsList.length > 0 ? false:true
    }

    @wire(getLeadInterviewsRecords, {
        recordId: '$recordId' 
    })
    getRelatedLeadInterviews({ error, data }) {
        if (data) {
            this.leadInterviewsList = data;  
            console.log('this.leadInterviewsList ::::::::',this.leadInterviewsList);        
            this.fecthError = undefined;
        } else if (error) {
            this.fecthError = error;
            this.leadInterviewsList = undefined;
        }
    }
    handleRowAction(event) {
        try {
            const action = event.detail.action.name;
            if(action === 'delete')
            this.rowactionDelete(event);          
        } catch (errorMsg) {
            console.log ('error occured inside handleRowAction() method. See actual system message <' + errorMsg.message + '>');
        } 
    }  

    async handleSave(event) {
        const records = event.detail.draftValues.slice().map((draftValue) => {
            const fields = Object.assign({}, draftValue);
            return { fields };
        });

        this.draftValues = [];

        try {
            const recordUpdatePromises = records.map((record) =>
                updateRecord(record)
            );
            await Promise.all(recordUpdatePromises);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead interview updated',
                    variant: 'success'
                })
            );
            await refreshApex(this.leadInterviewsList);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading Lead Interviews',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    async rowactionDelete(event) {
        
        deleteLeadInterview({ recordId: event.detail.row.Id } )
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Delete',
                    message: 'Record deleted with success',
                    variant: 'success'
                })
            ); 
            refreshApex(this.leadInterviewsList)     
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Could not delete this record',
                    variant: 'error'
                })
            );
        });     
    }

    // eslint-disable-next-line no-unused-vars
    errorCallback(error, stack) {
        this.error = error;
        console.log('Error :::::', JSON.stringify(error));
    }

}