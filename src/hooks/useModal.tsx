import { useContext } from "react";
import { ModalContext } from "../providers/ModalContext";



export const useModal = () => {
  const context = useContext(ModalContext);
  
  return context;
}



