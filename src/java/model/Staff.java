/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Huay
 */
@Entity
@Table(name = "STAFF")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Staff.findAll", query = "SELECT s FROM Staff s"),
    @NamedQuery(name = "Staff.findByStaffid", query = "SELECT s FROM Staff s WHERE s.staffid = :staffid"),
    @NamedQuery(name = "Staff.findByStfname", query = "SELECT s FROM Staff s WHERE s.stfname = :stfname"),
    @NamedQuery(name = "Staff.findByStfemail", query = "SELECT s FROM Staff s WHERE s.stfemail = :stfemail"),
    @NamedQuery(name = "Staff.findByStfcontactno", query = "SELECT s FROM Staff s WHERE s.stfcontactno = :stfcontactno"),
    @NamedQuery(name = "Staff.findByStfposition", query = "SELECT s FROM Staff s WHERE s.stfposition = :stfposition"),
    @NamedQuery(name = "Staff.findByStfusername", query = "SELECT s FROM Staff s WHERE s.stfusername = :stfusername"),
    @NamedQuery(name = "Staff.findByStfpswd", query = "SELECT s FROM Staff s WHERE s.stfpswd = :stfpswd")})
public class Staff implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 6)
    @Column(name = "STAFFID")
    private String staffid;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 30)
    @Column(name = "STFNAME")
    private String stfname;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 35)
    @Column(name = "STFEMAIL")
    private String stfemail;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 13)
    @Column(name = "STFCONTACTNO")
    private String stfcontactno;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "STFPOSITION")
    private String stfposition;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 35)
    @Column(name = "STFUSERNAME")
    private String stfusername;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 25)
    @Column(name = "STFPSWD")
    private String stfpswd;

    public Staff() {
    }

    public Staff(String staffid) {
        this.staffid = staffid;
    }

    public Staff(String staffid, String stfname, String stfemail, String stfcontactno, String stfposition, String stfusername, String stfpswd) {
        this.staffid = staffid;
        this.stfname = stfname;
        this.stfemail = stfemail;
        this.stfcontactno = stfcontactno;
        this.stfposition = stfposition;
        this.stfusername = stfusername;
        this.stfpswd = stfpswd;
    }

    public String getStaffid() {
        return staffid;
    }

    public void setStaffid(String staffid) {
        this.staffid = staffid;
    }

    public String getStfname() {
        return stfname;
    }

    public void setStfname(String stfname) {
        this.stfname = stfname;
    }

    public String getStfemail() {
        return stfemail;
    }

    public void setStfemail(String stfemail) {
        this.stfemail = stfemail;
    }

    public String getStfcontactno() {
        return stfcontactno;
    }

    public void setStfcontactno(String stfcontactno) {
        this.stfcontactno = stfcontactno;
    }

    public String getStfposition() {
        return stfposition;
    }

    public void setStfposition(String stfposition) {
        this.stfposition = stfposition;
    }

    public String getStfusername() {
        return stfusername;
    }

    public void setStfusername(String stfusername) {
        this.stfusername = stfusername;
    }

    public String getStfpswd() {
        return stfpswd;
    }

    public void setStfpswd(String stfpswd) {
        this.stfpswd = stfpswd;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (staffid != null ? staffid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Staff)) {
            return false;
        }
        Staff other = (Staff) object;
        if ((this.staffid == null && other.staffid != null) || (this.staffid != null && !this.staffid.equals(other.staffid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Staff[ staffid=" + staffid + " ]";
    }
    
}
