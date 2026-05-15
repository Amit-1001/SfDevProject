import { LightningElement,wire } from 'lwc';
import getAllCases from '@salesforce/apex/CaseHelper.getAllCases';
import closeCase from '@salesforce/apex/CaseHelper.closeCase';
import escalateCase from '@salesforce/apex/CaseHelper.escalateCase';
import{refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CaseDashboard extends LightningElement {

    caseList = [];
    isLoading = false;

    wiredResults;

    //Id,CaseNumber,Priority,Origin, Status
    columns =[
        {label:'Id', fieldName :'Id'},
        {label:'Case Number', fieldName:'CaseNumber'},
        {label:'Origin', fieldName:'Origin'},
        {label:'Priority', fieldName:'Priority'},
        {label:'Status', fieldName:'Status'},

        {
            label:'Close Case',
            type:'button',
            typeAttributes:{
                label:'Close',
                name :'close',
                variant:'brand'
            }
        },

        {
            label:'Escalate Case',
            type:'button',
            typeAttributes:{
                label:'Escalate',
                name:'escalate',
                variant:'destructive'
            }
        }
    ];

    // getting All cases 
    @wire(getAllCases)
    wireCaseList(result){
        this.wiredResults = result;
        if(result.data){
            this.caseList = result.data;
        }else if(result.error){
            console.log(result.error);
        }
    }

    handleRowAction(event){
        // here detail has whole tables in it
        // we can also use event.target.column
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if(actionName == 'close'){
            this.handleCaseClose(row.Id);

        }else if(actionName == 'escalate'){
            this.handleCaseEscalation(row.Id);
        }
    }

    handleCaseClose(recordId){
        this.isLoading = true;

        closeCase({recordId})
        .then(result=>{
            this.showToast('Success',result,'success');
            return refreshApex(this.wiredResults);
        })
        .catch(error=>{
            this.showToast('Error',error.body.message,'error');
        })
        .finally(()=>{
        this.isLoading = false;
        });
    }

    handleCaseEscalation(recordId){
        this.isLoading = true;

        escalateCase({recordId})
        .then(result=>{
            this.showToast('Success',result,'success');
            return refreshApex(this.wiredResults);
        })
        .catch(error=>{
            this.showToast('Error',error.body.message,'error');
        })
        .finally(()=>{
        this.isLoading = false;
        });

    }

      // 🔥 Toast helper
    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
    

}