import { useState, type ReactNode } from "react";
import { ModalContext } from "./ModalContext";
import type { Modal } from "../types/modals";


export function ModalProvider({children} : {children:ReactNode}) {
  const [modal,setModal] = useState<Modal|null>(null);

  return (
    <ModalContext.Provider value={{setModal}}>
      <div className="container">
        {modal?.child}    
      </div>
      {children}
    </ModalContext.Provider>
  )
}


