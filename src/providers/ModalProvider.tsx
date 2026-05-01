import { useState, type ReactNode } from "react";
import { ModalContext } from "./ModalContext";
import type { Modal } from "../types/modals";
import styles from "../components/modals/wrapper.module.css";
import { createPortal } from "react-dom";

export function ModalProvider({children} : {children:ReactNode}) {
  const [modal,setModal] = useState<Modal|null>(null);
  
  const closeModal = () => setModal(null); 

  return (
    <ModalContext.Provider value={{setModal,closeModal}}>
     
      {modal && createPortal(
        <div className={styles.container}>
          <div className={styles.content}>
            {modal.child} 
          </div>
        
        </div>
        ,document.getElementById("modal-root")!
        ) 
      }
      {children}
    
    </ModalContext.Provider>
  )
}


