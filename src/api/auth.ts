import type { LoginPayload, SignupPayload, User } from "../types/auth"


export const getUser = async () :Promise<User> => {
  return {
    id:12312,
    gmail: "hello@gmail.com",
    name:"Aidar",
    surname:"Negrovich",
    group: 23,
    year: 323
  }
}



export const loginApi = async (
  {email,password} : LoginPayload
) : Promise<User> => {
  
  return {
    email: email,
    id: 12312,
    name: "Азик",
    surname:"Мазмуджанов",
    group: 2,
    year: 1
 
  }

}



export const signupApi = async (
  data : SignupPayload 
): Promise<User> => {
   return {
    gmail: "hello@gmail.com",
    id: 12312,
    name: "Aidar",
    surname:"Negrovich",
    group: 23,
    year: 323
  }

 
}



export const logoutApi = async () : Promise<void> => {
  return;
}





