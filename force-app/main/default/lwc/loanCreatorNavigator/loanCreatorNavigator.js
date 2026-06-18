import { LightningElement } from 'lwc';

import {encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import { NavigationMixin } from 'lightning/navigation';


export default class LoanCreatorNavigator extends NavigationMixin(LightningElement) {

    handleNewLoan(){
        // Default field value
        const defaultValue = encodeDefaultFieldValues({
            Status__c : 'Pending',
            Loan_Amount__c : 50000
        });


        // Navigate
        this[NavigationMixin.Navigate]({ // bracket notion
            type: 'standard__objectPage',
            attributes:{
                objectApiName :'Loan_Application__c',
                actionName :'new'
            },
            state:{
                defaultFieldValues:defaultValue
            }
        });

    }


}