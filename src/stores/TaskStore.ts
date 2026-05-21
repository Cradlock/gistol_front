import { create } from "zustand";
import type { Task } from "../types/task";
import { getTaskApi, getTasksApi } from "../api/task";
import type { Result } from "../types/res";



interface TaskState {
  currentTask: Task | null,
  tasks: Task[],
  getTask: (id:string) => Promise<Result>,
  getTasks: () => Promise<void>
};

const useTask = create<TaskState>((set) => ({
  currentTask: null,
  tasks: [],
  getTask: async (id: string) => {
    try{
      const res = await getTaskApi(id);
      set({currentTask: res});
      return {success:true}
    } catch(err) {
      set({currentTask: null});
      return {success:false} 
    }  
  },
  getTasks: async () => {
    try{
      const tasks = await getTasksApi();
      set({tasks: tasks});
    } catch(err) {
    
    } 
  }
})) 


export default useTask
