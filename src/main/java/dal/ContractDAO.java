/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
public class ContractDAO extends DBContext {
    
    public List<Contract> searchContracts(String keyword, String status, int pageIndex, int pageSize, String sortBy, String sortOrder) {
        List<Contract> lst = new ArrayList<>();
        int offset = (pageIndex - 1) * pageSize;
        
    
    
        return null;
        
    
    
    }
    
}
