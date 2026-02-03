import { LightningElement , track} from 'lwc';

export default class TaskList extends LightningElement {
    
    @track taskName = '';
    @track taskPriority = 'Medium'; // Default value for the picklist
    @track tasks = []; // Array to store the list of tasks

    // Options for the Priority picklist
    priorityOptions = [
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' },
    ];

    // Handle changes in the Task Name input
    handleNameChange(event) {
        this.taskName = event.target.value;
    }

    // Handle changes in the Priority picklist
    handlePriorityChange(event) {
        this.taskPriority = event.detail.value;
    }

    // Handle the button click to add a new task
    addTask() {
        if (this.taskName) {
            const newTask = {
                id: Date.now(), // Use a unique ID for the key attribute
                name: this.taskName,
                priority: this.taskPriority,
            };
            
            this.tasks = [...this.tasks, newTask]; // Add the new task to the array

            // Reset input fields after adding
            this.taskName = ''; 
            this.taskPriority = 'Medium';
        } else {
            // Optionally add error handling or toast message for empty name
            alert('Please enter a task name.');
        }
    }
}