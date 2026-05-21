// В файле, где лежит ваш ModalContext
import { useContext } from "react";
import { ModalContext } from "../providers/ModalContext";

export function useModal() {
  const context = useContext(ModalContext);
  
  // Если контекст равен null, значит мы забыли обернуть приложение в <ModalProvider>
  if (!context) {
    throw new Error("useModal должен использоваться строго внутри ModalProvider");
  }
  
  // Здесь TypeScript уже УВЕРЕН, что context — это ModalContextType, а не null
  return context; 
}

