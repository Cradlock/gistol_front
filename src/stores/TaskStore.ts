import { create } from "zustand";
import type { Task } from "../types/task";



interface TaskState {
  currentTask: Task | null, 
};

const useTask = create<TaskState>((set) => ({
  currentTask: null,
  getTask: async (id: string) => {
      
  }
})) 


export default useTask
