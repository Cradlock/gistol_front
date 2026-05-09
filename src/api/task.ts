import type { Task } from "../types/task";


export const getTaskApi = async (id:string): Promise<Task> => {
  
  return {
    id: id,
    title: "Что такое ...",
    is_answered: false,

  }
}




