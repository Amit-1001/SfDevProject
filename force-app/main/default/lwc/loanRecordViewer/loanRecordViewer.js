import { api, LightningElement, wire } from 'lwc';

import { getRecord, getFieldValue , updateRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Schema Imports
import NAME_FIELD
from '@salesforce/schema/Loan_Application__c.Name';

import AMOUNT_FIELD
from '@salesforce/schema/Loan_Application__c.Loan_Amount__c';

import STATUS_FIELD
from '@salesforce/schema/Loan_Application__c.Status__c';

import CUSTOMER_NAME_FIELD
from '@salesforce/schema/Loan_Application__c.Customer__r.Name';


const FIELDS = [
        NAME_FIELD,
        AMOUNT_FIELD,
        STATUS_FIELD,
        CUSTOMER_NAME_FIELD
    ];

export default class LoanRecordViewer extends LightningElement {

    @api recordId

    isLoading = false;
    
    //wire Adapater
    @wire(getRecord,{recordId:'$recordId', fields:FIELDS})
    loanRecord;


    get loanName(){
        return getFieldValue(this.loanRecord.data,NAME_FIELD);
    }

    get loanAmount(){
        return getFieldValue(this.loanRecord.data,AMOUNT_FIELD);
    }

    get loanStatus(){
        return getFieldValue(this.loanRecord.data,STATUS_FIELD);
    }

    get loanCustomerName(){
        return getFieldValue(this.loanRecord.data,CUSTOMER_NAME_FIELD);
    }

    // Dyanamic CSS
    get statusClass(){
        if(this.loanStatus == 'Approved'){
            return 'green';
        }else if(this.loanStatus == 'Rejected'){
            return 'red';
        }
        else{
            return 'default';
        }
    }

    get hasRecord(){
        return (this.loanRecord.data !=null);
    }

    handleApprove(){
        this.updateStatus('Approved');
    }

    handleReject(){
        this.updateStatus('Rejected');
    }

    updateStatus(Status){
        this.isLoading = true;
         // Fields Object
        const fields ={
            Id: this.recordId,
            Status__c: Status
        }
        // above here we hardcoded the Field Name instead we can use FieldApiName

        /**     production grade
         *      const field={
         *          Id: this.recordId,
         *          STATUS_FIELD.fieldApiName: status 
         * }
         */

        //Input to updateRecord 
        const recordInput = {
            fields
        }

        //LDS Update Record Automatically refresh the data on UI and has in built caching, FLS etc.
        updateRecord(recordInput)
        .then(result=>{
            this.showToast('Success',result,'success');
        })
        .catch(error=>{
            this.showToast('Error', error.body.message,'error');
        })
        .finally(()=>{
            this.isLoading = false;
        })

    }



    showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })

        );
    }



}