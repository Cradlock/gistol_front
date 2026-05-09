import { create } from "zustand";
import type { User } from "../types/auth";
import { getUser, loginApi, logoutApi, signupApi } from "../api/auth";


const useAuth = create((set) => ({
  user: null,
  isAdmin: false,
  getUser: async () => {
    const data = await getUser();
    set({user:data});
  },
  login: async ({email,password} : {email:string,password:string}) => {
    try{
      const data = await loginApi({email,password});
      set({user:data});
      return { success: true };
    } catch (err: unknown) {
      return { success: false, message: "Ошибка" };
    }
  },
  signup: async (data : Omit<User,"id">) => {
    try{
      const user = await signupApi(data);
      set({user:user});
      return {success: true};
    }catch (err: unknown){
      return { success: false,message: "Ошибка" }
    }
  },
  logout: async () => {
    await logoutApi();
    set({user: null})
  } 
}))


export default useAuth




