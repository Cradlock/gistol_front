import { BrowserRouter, Route, Routes } from "react-router-dom"
import MainPage from "./pages/Main/page"
import { Header } from "./components/header/main"
import { ProfilePage } from "./pages/Profile/page"


function App() {
  


  return (
    <>
     <BrowserRouter>
        <Header />   


        <Routes>
          <Route path="/" element={<MainPage/>} /> 
          <Route path="/me" element={<ProfilePage/>} /> 
           
        </Routes>
     </BrowserRouter>         
    </>
  )
}

export default App
