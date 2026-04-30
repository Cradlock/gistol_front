import { useState, type ReactNode } from "react"
import { NotifyContext } from "./NotifyContext"
import type { Notify, NotifyType } from "../types/notify";

import styles from "../components/notify/wrapper.module.css";
import NotifyCard from "../components/notify/notifyCard";


export const NotifyProvider = ({ children } : { children: ReactNode }) => {
  const [ notifications ,setNotifications ] = useState<Notify[]>([]);
 
  const addNotify = (
    msg: string, type: NotifyType,duration: number = 3000
  ) => {
    const newNotify : Notify = {id: Date.now(),msg,type}; 
    setNotifications(prev => [...prev,newNotify]);
  
    setTimeout(() => {
      setNotifications(prev => prev.filter(n => n.id !== newNotify.id));
    },duration);
  };  
  

  return (
    <NotifyContext.Provider value={{notifications,setNotifications,addNotify}}>
      <div className={styles.notifyWrapper}> 
        {notifications.map((n) => 
          <NotifyCard key={n.id} type={n.type} msg={n.msg} />
        )}
      </div>
      {children}

    </NotifyContext.Provider>
  )  
}

