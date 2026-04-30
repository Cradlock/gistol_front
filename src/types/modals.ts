import type { Dispatch, ReactNode, SetStateAction } from "react";


export interface Modal { 
  id: number,
  child: ReactNode 
};

export interface ModalsContextType{
  modals: Modal[],
  setModals: Dispatch<SetStateAction<Modal[]>>,
};


