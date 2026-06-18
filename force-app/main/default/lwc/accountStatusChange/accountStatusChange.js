import getAccountById from '@salesforce/apex/AccountLWCHelper.getAccountById';
import deactivateAccount from '@salesforce/apex/AccountLWCHelper.deactivateAccount';

import { api, LightningElement,wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex'; // Needed to refresh @wire 

export default class AccountStatusChange extends LightningElement {

    @api
    recordId

    account;

    wiredResult;

    isLoading = false;

    @wire(getAccountById,{recordId:'$recordId'})
    wiredAccount(result){
        if(result.data){
            this.wiredResult = result;
            this.account = result.data;
        }else if(result.error){
            console.log(result.error);
        }
    }

    // Imperative Apex 
    handleClick(){
        this.isLoading = true;// making spinner visible
        deactivateAccount({recordId:this.recordId})
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title :'Success',
                    message : result,
                    variant : 'success'
                })
            );
        return refreshApex(this.wiredResult); 
        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title :'error',
                    message : error.body.message,
                    variant : 'error'
                })
            );
        })
        .finally(()=>{
            this.isLoading = false; // Disabling spinner
        })
    }


}