import { createContext} from "react";
import type { NotifyContextType } from "../types/notify";



export const NotifyContext = createContext<NotifyContextType | null>(null);




