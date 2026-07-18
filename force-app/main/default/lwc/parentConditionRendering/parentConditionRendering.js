import { LightningElement } from 'lwc';

export default class ParentConditionRendering extends LightningElement {


    selectedComponent;
    message;
    handleClick(event){
        this.selectedComponent = event.target.dataset.name;
        
    }

    handleChildEvent(event){
        this.message = event.detail;
    }

    get showChildA(){
        return this.selectedComponent === 'childA';
    }

    get showChildB(){
        return this.selectedComponent === 'childB';
    }
}