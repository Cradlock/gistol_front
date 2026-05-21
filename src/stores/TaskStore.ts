import { create } from "zustand";
import type { Task } from "../types/task";



interface TaskState {
  currentTask: Task | null,
  tasks: Task[]
};

const useTask = create<TaskState>((set) => ({
  currentTask: null,
  tasks: [],
  getTask: async (id: string) => {
     
  },
  getTasks: async () => {
    
  }
})) 


export default useTask
