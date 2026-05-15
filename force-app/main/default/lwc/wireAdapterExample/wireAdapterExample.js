import { api, LightningElement, wire } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_FIELD_NAME from '@salesforce/schema/Account.Name';
export default class WireAdapterExample extends LightningElement {

    @api recordId;

    @wire(getRecord,{recordId: '$recordId', fields:[ACCOUNT_FIELD_NAME]})
    record; 

    get name(){
        return getFieldValue(this.record.data,ACCOUNT_FIELD_NAME);
    }



}