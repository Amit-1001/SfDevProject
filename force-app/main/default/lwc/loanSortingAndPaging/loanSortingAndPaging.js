import { LightningElement ,wire} from 'lwc';

import getAllLoans from '@salesforce/apex/LoanApplicationHelper.getAllLoans';


export default class LoanSortingAndPaging extends LightningElement {

    loanList = [];

    sortedBy;

    sortDirection;

    columns = [

        {label:'Id',fieldName:'Id'},

        {label:'Name',fieldName:'Name'},

        {label:'Customer Name',fieldName:'CustomerName'},

        {
            label:'Amount',
            fieldName:'Loan_Amount__c',
            type:'number',
            sortable:true
        }
    ];

    @wire(getAllLoans)
    wiredLoans(result){

        if(result.data){
            // flatting of data
            this.loanList =
            result.data.map(loan => {

                return {

                    ...loan,

                    CustomerName:loan.Customer__r.Name
                };
            });

        }
        else if(result.error){

            console.log(result.error);
        }
    }

    get hasList(){

    return this.loanList && this.loanList.length > 0;
    }

    handleSort(event){

        this.sortedBy =
            event.detail.fieldName;

        this.sortDirection =
            event.detail.sortDirection;

        let tempList =
            [...this.loanList]; // it is good idea to sort loanList with temp var , we should avoid directly sorting wiredResult

        if(this.sortDirection === 'asc'){

            tempList.sort((a,b)=>{

            return a.Loan_Amount__c - b.Loan_Amount__c;
            });

        }
        else{

            tempList.sort((a,b)=>{

            return b.Loan_Amount__c - a.Loan_Amount__c;
            });
        }

        this.loanList = tempList;
    }
}