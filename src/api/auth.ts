import type { LoginPayload, SignupPayload, User } from "../types/auth"


export const getUser = async () :Promise<User> => {
  return {
    id:12312,
    email: "hello@gmail.com",
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
    email: email+password,
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
    console.log(data)
   return {
    email: "hello@gmail.com",
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





