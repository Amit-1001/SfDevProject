import { LightningElement } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NAME_FIELD  from '@salesforce/schema/Account.Name';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import ACCOUNT_OBJ from '@salesforce/schema/Account';

import { createRecord } from 'lightning/uiRecordApi';

export default class ChildAccountInformation extends LightningElement {

    accountName = '';
    rating = '';
    industry = '';

    isLoading = false;

    isDisable = false;


    handleName(event){
        this.accountName = event.target.value;
    }

    handleRating(event){
        this.rating = event.target.value;
    }

    handleIndustry(event){
        this.industry = event.target.value;    
    }

    handleSave(event){
        this.isLoading = true;
        this.isDisable = true;

        const fields ={
        [NAME_FIELD.fieldApiName]: this.accountName,
        [RATING_FIELD.fieldApiName]: this.rating,
        [INDUSTRY_FIELD.fieldApiName]: this.industry
        }

        const recordInput ={
            apiName: ACCOUNT_OBJ.objectApiName,
            fields
        }

        this.dispatchEvent(
            new CustomEvent('childsave',{detail:recordInput})
        );

        this.accountName = '';
        this.rating = '';
        this.industry = '';

        this.isLoading = false;
        this.isDisable = false;

    }

}