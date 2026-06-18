import { LightningElement, track } from 'lwc';

export default class DisplayList extends LightningElement {
    
    @track
    languages = ['LWC', 'APEX', 'JAVA', 'PYTHON'];

}