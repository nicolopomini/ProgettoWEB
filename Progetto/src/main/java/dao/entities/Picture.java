/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao.entities;

/**
 *
 * @author Gabriele
 */
public class Picture {
    private Integer pictureId;
    private String path;
    private Integer itemId;

    public Integer getPictureId() {
        return pictureId;
    }

    public String getPath() {
        return path;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setPictureId(Integer pictureId) {
        this.pictureId = pictureId;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    @Override
    public String toString() {
        return "Picture{" + "pictureId=" + pictureId + ", path=" + path + ", itemId=" + itemId + '}';
    }
}
