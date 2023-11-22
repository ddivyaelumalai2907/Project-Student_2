package com.training.controller;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.ui.Model;



import com.fasterxml.jackson.core.JsonProcessingException;
import org.json.JSONException;
import com.training.TrainingUiApplication;
import com.training.util.RestUtil;

@Configuration
@RestController
public class TrainingController {
    @Autowired
    private RestUtil restUtil;
    public static String student_result = null; 
    public String sid = null;
    String status = null;

    private static final Logger LOGGER = LogManager.getLogger(TrainingController.class);

    @GetMapping(value="/test")
    public String test() {
        return "Works!";
    }

     @GetMapping(value="/login")
    public ModelAndView login() {
        return new ModelAndView("login");
    }

    //student login using id
    @GetMapping(value="/login/student")
    public ModelAndView studentlogin(){
        return new ModelAndView("login/student");
    }

   /* @PostMapping(value="/dologin")
    public String doLogin(HttpSession session, String userName, String password) throws JsonProcessingException {
        JSONObject response = new JSONObject();
        if("user".equals(userName) && "pswd".equals(password)) {
            session.setAttribute("user_id",6);
            response.put("status", "success");
            response.put("message", JSONObject.NULL);
            response.put("data", "yes");
        } else {
            response.put("status", "failure");
            response.put("message", "Invalid login credentials!");
            response.put("data", JSONObject.NULL);
        }

        return response.toString();
    }*/

    @GetMapping(value="/home")
    public ModelAndView home(HttpSession session, ModelAndView mv) {
        Integer userId = (Integer) session.getAttribute("user_id");
        if(userId != null) {
            return new ModelAndView("home");
        }
        return new ModelAndView("redirect:/login");
    }

    //student/details
    @GetMapping(value="check/student/{id}")
    public String studentLogin(HttpSession session,@PathVariable("id") String student_id)throws JSONException {
         sid = student_id;
        try{
            //id = student_id;
            Map<String,Object> params = new HashMap<String,Object>();
            String getstudent = restUtil.get("http://localhost:5000/student/"+student_id, params);
            System.out.println(getstudent);
            
            JSONObject json = new JSONObject(getstudent);
            status = json.getString("status");
            System.out.println(status);
            return getstudent;    
        }catch(Exception ex) {
            LOGGER.error("details", ex);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }

    }

    @GetMapping(value="/login/register")
      public ModelAndView login_register() {
        return new ModelAndView("login/register");
     }
     
     @GetMapping(value="/student/details/{id}")
     public ModelAndView viewstudents(HttpSession session,@PathVariable("id") String id) {
        if(status.equals("success")){
           return new ModelAndView("student/details/{id}");
        }
       
         return new ModelAndView("redirect:login/register");
        
    }

    //geting student deatails based on user data
    @GetMapping(value="/student/data")
    public String details(HttpSession session) {
        try {
            if(sid != null) {
                Map<String, Object> params = new HashMap<String, Object>();
                String details = restUtil.get("http://localhost:5000/student/"+sid, params);
                return details;
            }

            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "You need to be logged in to view details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        } catch(Exception ex) {
            LOGGER.error("details", ex);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }
    }

    @PostMapping(value="/add/student")
    public String new_student(String name,HttpSession session){
        try{
            Map<String,Object>params = new HashMap<String,Object>();
            params.put("name",name);
            System.out.println(name);
            String student = restUtil.post("http://localhost:5000/add/student", params);
            
            JSONObject json = new JSONObject(student);
            status = json.getString("status");
            System.out.println(status);
            
            return student;
        }catch(Exception e){
            LOGGER.error("details", e);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }
    }

    @GetMapping(value="/student/details/new")
     public ModelAndView viewstudents(HttpSession session) {
        if("success".equals(status)){
           return new ModelAndView("login/student");
        } 
         return new ModelAndView("redirect:login/register");
        
    }

    //getting subjects that enrolled by student
     @GetMapping(value="/students/erolled/subject")
    public String studentenrolled(HttpSession session) {
         try {
            if(sid != null) {
                Map<String, Object> params = new HashMap<String, Object>();
                String details = restUtil.get("http://localhost:5000/enrolled/subjects/"+sid, params);
                return details;
            }
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "You need to be logged in to view details!");
            response.put("data", JSONObject.NULL);

            return response.toString();

        } catch(Exception ex) {
            LOGGER.error("details", ex);
            JSONObject response = new JSONObject();
            response.put("status", "failure");
            response.put("message", "Unable to get the details!");
            response.put("data", JSONObject.NULL);

            return response.toString();
        }
    }
    @GetMapping(value="/subject_details")
    public String getsubject(HttpSession session){
        try{
            Integer userId = (Integer)session.getAttribute("user_id");
            //METHOD-1
           /*  if(userId != null){
                if(subjectRespone == null){
                Map<String,Object> params = new HashMap<String,Object>();
                subjectRespone = restUtil.get("http://localhost:5000/subject", params);
                return sub;
            }*/
            //METHOD-2 this intialize subjects once while satrting a application
            if(userId !=null){
                return TrainingUiApplication.getsubjects();
            }
        
            JSONObject response = new JSONObject();
            response.put("status","failure" );
            response.put("message","You need to logged in to view deatils" );
            response.put("data",JSONObject.NULL);

            return response.toString();
        }
        catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       

            return response.toString();
        }
    }

   @PostMapping(value="/subject/subscribe")
    public String subjects_subscribe(HttpSession session,String subject_id) throws JsonProcessingException {
        try{
            Map<String,Object> params = new HashMap<String,Object>();
            System.out.println(sid);
            params.put("student_id",sid);
            params.put("subject_id", subject_id);
            System.out.println(params);
            String enroll = restUtil.post("http://localhost:5000/student/subscribe",params);
            return enroll;
        }
            catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }
//IF WE MADE ANY CHANGES IN DB OF SUBJECTS WE CALL THIS END POINT
    @GetMapping(value="/calibrate")
    public String set_subject(HttpSession session){
        try{
           // Integer userId = (Integer)session.getAttribute("user_id");
            TrainingUiApplication.refresh();
            JSONObject response = new JSONObject();
            response.put("status","success" );
            response.put("message","You are added new details" );
            response.put("data",JSONObject.NULL);

            return response.toString();
        }
        catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       

            return response.toString();
        }
    }

//for deleting the student_subject
   @DeleteMapping(value="/subject/delete")
    public String quit(HttpSession session,String subject_id) throws JsonProcessingException {
        try{
          //  Integer userId = (Integer)session.getAttribute("user_id");
            if(sid!=null){
                Map<String,Object> params = new HashMap<String,Object>();
                params.put("student_id",sid);
                params.put("subject_id", subject_id);
                System.out.println(params);
                String result = restUtil.delete("http://localhost:5000/quit/course",params);
                return result;
            }else{
                JSONObject response = new JSONObject();
                response.put("status","failure" );  
                response.put("message","Unable to get details"); 
                response.put("data",JSONObject.NULL);       
                return response.toString();
            }    

        }catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }

    @PutMapping(value="/student/update/name")
    public String update_student_name(HttpSession session,String old_name,String new_name) throws JsonProcessingException {
        try{
            Integer userId = (Integer)session.getAttribute("user_id");
            if(sid!=null){
                Map<String,Object> params = new HashMap<String,Object>();
                params.put("old_name",old_name);
                params.put("new_name",new_name);
                System.out.println(params);
                String result = restUtil.put("http://localhost:5000/update/student_name",params);
                return result;
            }else{
                JSONObject response = new JSONObject();
                response.put("status","failure" );  
                response.put("message","Unable to get details"); 
                response.put("data",JSONObject.NULL);       
                return response.toString();
            }    

        }catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }

//*********************************ADMIN************************//


    @GetMapping(value="/adminlogin")
    public ModelAndView admin() {
        return new ModelAndView("adminlogin");
    }
    @PostMapping(value="/adminlogin")
    public String admindoLogin(HttpSession session, String userName, String password) throws JsonProcessingException {
        JSONObject response = new JSONObject();
        if("admin".equals(userName) && "admin1".equals(password)) {
            response.put("status", "success");
            response.put("message", JSONObject.NULL);
            response.put("data", "yes");
        } else {
            response.put("status", "failure");
            response.put("message", "Invalid login credentials!");
            response.put("data", JSONObject.NULL);
        }

        return response.toString();
    }

     @GetMapping(value="/admin")
    public ModelAndView admin(HttpSession session, ModelAndView mv) {
            return new ModelAndView("admin");
    }

    @GetMapping(value="/allsubjectdetails")
    public String getallsubjects(HttpSession session){
        try{
            //METHOD-1
                Map<String,Object> params = new HashMap<String,Object>();
                String subjects = restUtil.get("http://localhost:5000/all/subjects",params);
               // System.out.println(subjects);
                return subjects;
        }catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       

            return response.toString();
        }
    }

    @PostMapping(value="/new/subject")
    public String new_subjects(HttpSession session,String subject_name) throws JsonProcessingException {
        try{
            Map<String,Object> params = new HashMap<String,Object>();
            params.put("subject_name", subject_name);
            System.out.println(params);
            String result = restUtil.post("http://localhost:5000/add/subject",params);
            return result;
        }
            catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }
 @DeleteMapping(value="/delete/course")
    public String quit(HttpSession session,int subject_id,String subject_name) throws JsonProcessingException {
        try{
            Integer userId = (Integer)session.getAttribute("user_id");
            if(userId!=null){
                Map<String,Object> params = new HashMap<String,Object>();
                params.put("subject_id",subject_id);
                params.put("subject_name", subject_name);
                //System.out.println(params);
                String result = restUtil.delete("http://localhost:5000/remove/course",params);
                return result;
            }else{
                JSONObject response = new JSONObject();
                response.put("status","failure" );  
                response.put("message","Unable to get details"); 
                response.put("data",JSONObject.NULL);       
                return response.toString();
            }    

        }catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }

    @PutMapping(value="/modify/subject")
    public String updatesubject(HttpSession session,String old_name,String new_name) throws JsonProcessingException {
        try{
                Map<String,Object> params = new HashMap<String,Object>();
                params.put("old_name",old_name);
                params.put("new_name", new_name);
                System.out.println(params);
                String result = restUtil.put("http://localhost:5000/update/subject",params);
                return result;

        }catch(Exception ex){
           // LOGGER.error("details",ex);
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       
            return response.toString();
        }
    }
    //viewing the students enrolled for specific subject
   @GetMapping(value="/get/studentsubject/subid/{id}")
   public static String getstudentsubject(@PathVariable("id") String id,HttpSession session,Model mv)throws JsonProcessingException{
        try{
                RestUtil restUtil = new RestUtil();
                Map<String,Object> params = new HashMap<String,Object>();
                student_result = restUtil.get("http://localhost:5000/view/students/"+id ,params);
                return student_result;
        }catch(Exception ex){
            JSONObject response = new JSONObject();
            response.put("status","failure" );  
            response.put("message","Unable to get details"); 
            response.put("data",JSONObject.NULL);       

            return response.toString();
        }
    }
    @GetMapping(value="/students/enrolled/{name}")
    public ModelAndView viewstudents(@PathVariable("name") String name,HttpSession session, ModelAndView mv) {
        ModelAndView modelAndView = new ModelAndView("/students/enrolled/{name}");
        return modelAndView;
    }
    public static String getstudents(){
        return student_result;
    }
}
