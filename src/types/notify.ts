import type { Dispatch, SetStateAction } from "react";



export type NotifyType = "info" | "warning" | "error";

export interface Notify {
  type: NotifyType,
  msg: string,
  id: number 
};



export interface NotifyContextType{
  setNotifications: Dispatch<SetStateAction<Notify[]>>
  addNotify: (msg:string,type:NotifyType,duration: number) => void
};



