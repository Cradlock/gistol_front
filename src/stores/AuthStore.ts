import { create } from "zustand";
import type { User } from "../types/auth";
import { getUser } from "../api/auth";


const useAuth = create((set) => ({
  user: null,
  login: async () => {
    const data = await getUser();
    set({user:data});
  },
  logout: () => set(() => ({
    user: null
  })) 
}))


export default useAuth

