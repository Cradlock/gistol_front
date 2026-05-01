import { BrowserRouter, Route, Routes } from "react-router-dom"
import MainPage from "./pages/Main/page"
import { Header } from "./components/header/main"


function App() {

  return (
    <>
     <BrowserRouter>
        <Header />   


        <Routes>
          <Route path="/" element={<MainPage/>} /> 
           
        </Routes>
     </BrowserRouter>         
    </>
  )
}

export default App
