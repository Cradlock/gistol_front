import type { Dispatch, ReactNode, SetStateAction } from "react";


export interface Modal { 
  child: ReactNode 
};

export interface ModalContextType{
  setModal: Dispatch<SetStateAction<Modal | null>>,
};


