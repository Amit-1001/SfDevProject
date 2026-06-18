import { LightningElement } from 'lwc';

import getPaginatedCases from '@salesforce/apex/CaseHelper.getPaginatedCases';

export default class CaseServersidePaginationDashboard extends LightningElement {

    pageSize = 5;

    currentPage = 1;

    caseList = [];

    isLoading = false;

    totalPages = 0;

    columns =[
        {label:'Id', fieldName :'Id'},
        {label:'Case Number', fieldName:'CaseNumber'},
        {label:'Origin', fieldName:'Origin'},
        {label:'Priority', fieldName:'Priority'},
        {label:'Status', fieldName:'Status'},
    ];

    connectedCallback(){
        this.loadCases();
    }


    loadCases(){
        this.isLoading = true;
        getPaginatedCases({
            pageSize:this.pageSize,
            pageNumber: this.currentPage
        })
        .then(result=>{
            this.caseList = result;

            this.totalPages = Math.ceil(this.caseList.length/this.pageSize);
        })
        .catch(error=>{
            console.log(error);
        })
        .finally(()=>{
            this.isLoading = false;
        })
    }

    handlePrevious(){
        if(this.currentPage >1){
            this.currentPage--;
            this.loadCases();
        }
    }

    handleNext(){
            
                this.currentPage++;
                this.loadCases();
            
        }


    get hasList(){
        return this.caseList!=null && this.caseList.length>0
    }
}

