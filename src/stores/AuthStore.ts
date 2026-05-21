import { create } from "zustand";
import type { LoginPayload, SignupPayload, User } from "../types/auth";
import { getUser, loginApi, logoutApi, signupApi } from "../api/auth";
import type { Result } from "../types/res";


interface AuthState {
  // State
  user: User | null;
  isAdmin: boolean;

  // Actions
  getUser: () => Promise<void>;
  login: (data: LoginPayload) => Promise<Result>;
  signup: (data: SignupPayload) => Promise<Result>;
  logout: () => Promise<void>;
}


const useAuth = create<AuthState>((set) => ({
  user: null,
  isAdmin: false,

  getUser: async () => {
    try {
      const data = await getUser();
      set({ user: data }); // Пример логики для isAdmin
    } catch (error) {
      set({ user: null, isAdmin: false });
    }
  },

  login: async (payload: LoginPayload): Promise<Result> => {
    try {
      const data = await loginApi(payload);
      set({ user: data});
      return { success: true };
    } catch (err: unknown) {
      // Здесь можно добавить более детальную обработку ошибок через axios.isAxiosError
      return { success: false, message: "Неверный логин или пароль" };
    }
  },

  signup: async (payload: SignupPayload): Promise<Result> => {
    try {
      const data = await signupApi(payload);
      set({ user: data });
      return { success: true };
    } catch (err: unknown) {
      return { success: false, message: "Ошибка при регистрации" };
    }
  },

  logout: async () => {
    try {
      await logoutApi();
    } finally {
      // Сбрасываем стейт в любом случае
      set({ user: null, isAdmin: false });
    }
  },
}));

export default useAuth;
