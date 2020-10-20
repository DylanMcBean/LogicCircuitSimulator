import java.io.ByteArrayOutputStream; //<>//
import java.util.zip.*;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

public static byte[] compress(byte[] in) {
    try {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        DeflaterOutputStream defl = new DeflaterOutputStream(out);
        defl.write(in);
        defl.flush();
        defl.close();

        return out.toByteArray();
    } catch (Exception e) {
        e.printStackTrace();
        System.exit(150);
        return null;
    }
}

public static byte[] decompress(byte[] in) {
    try {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        InflaterOutputStream infl = new InflaterOutputStream(out);
        infl.write(in);
        infl.flush();
        infl.close();

        return out.toByteArray();
    } catch (Exception e) {
        e.printStackTrace();
        System.exit(150);
        return null;
    }
}

public byte[] zipCompress(String data) {
  byte[] compressed;
  try{
    ByteArrayOutputStream bos = new ByteArrayOutputStream(data.length());
    GZIPOutputStream gzip = new GZIPOutputStream(bos);
    gzip.write(data.getBytes());
    gzip.close();
    compressed = bos.toByteArray();
    bos.close();
  } catch (IOException e) {
    return null;
  }
  return compressed;
}

public String zipDecompress(byte[] compressed) {
  StringBuilder sb;
  try{
    ByteArrayInputStream bis = new ByteArrayInputStream(compressed);
    GZIPInputStream gis = new GZIPInputStream(bis);
    BufferedReader br = new BufferedReader(new InputStreamReader(gis, "UTF-8"));
    sb = new StringBuilder();
    String line;
    while((line = br.readLine()) != null) {
      sb.append(line);
    }
    br.close();
    gis.close();
    bis.close();
  } catch (IOException e) {
    return null;
  }
  return sb.toString();
}
