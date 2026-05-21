

export interface User{
  id: number,
  email: string,
  name: string,
  surname: string,
  group: number,
  year: number
};

export interface LoginPayload {
  email: string;
  password: string;
}

export type SignupPayload = Omit<User, "id">;






