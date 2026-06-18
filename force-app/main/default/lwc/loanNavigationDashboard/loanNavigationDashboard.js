import { LightningElement , track, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getAllLoans from '@salesforce/apex/LoanApplicationHelper.getAllLoans';

export default class LoanNavigationDashboard extends NavigationMixin(LightningElement){

    @track loanList =[];



    columns =[
        {label: 'Id', fieldName : 'Id'},
        {label: 'Loan Name', fieldName : 'Name'},
        {label: 'Amount', fieldName : 'Loan_Amount__c', type:'number'},
        {label: 'Customer Name' , fieldName : 'CustomerName'},

        {   
            label: 'View',
            type: 'button',
            typeAttributes: {

                label: 'View',

                name: 'view',

                variant: 'brand'
            }
        },
        {
            label: 'Edit',
            type: 'button',
            typeAttributes:{
                label:'Edit',
                name: 'edit',
                variant: 'neutral'
            }
        }
    ];

    @wire(getAllLoans)
    wiredLoans(result){
            if(result.data){
                //flatenning the related field
                this.loanList = result.data.map(loan=>{
                    return{
                        ...loan,
                        CustomerName: loan.Customer__r.Name
                    }
                })
            }else{
                console.log("getAllLoan Error:"+result.error);
            }
    }


    handleRowAction(event){
    
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if(actionName == 'view'){
            this.navigateToRecord(actionName,row.Id);
        }else if( actionName == 'edit'){
            this.navigateToRecord(actionName,row.Id);
        }
    }

    navigateToRecord(actionName,recordId){


        this[NavigationMixin.Navigate](
            {
                    type: 'standard__recordPage',

                attributes: {

                    recordId: recordId,

                    objectApiName:
                    'Loan_Application__c',

                    actionName: actionName
                }
            }
        );


    }

    get hasList(){
        return !!this.loanList && this.loanList.length > 0;
    }

}