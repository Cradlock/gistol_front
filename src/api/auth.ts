import type { User } from "../types/auth"


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
  {email,password} : {
    email:string,password:string 
  }
) : Promise<User> => {
  
  return {
    gmail: "hello@gmail.com",
    id: 12312,
    name: "Aidar",
    surname:"Negrovich",
    group: 23,
    year: 323
 
  }

}



export const signupApi = async (
  data : Omit<User,'id'> 
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





